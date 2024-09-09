require 'xcodeproj'

# Define the relative path to your Xcode project
project_path = File.join(Dir.pwd, 'todoapp2.xcodeproj')
project = Xcodeproj::Project.open(project_path)

# Function to sync a folder to a group in Xcode, ensuring no duplicates and proper syncing
def sync_folder_to_group(project, group, folder_path, indent = '')
  puts "#{indent}Syncing folder: #{folder_path}"
  
  existing_files = group.files.map(&:path)
  existing_groups = group.groups.map(&:display_name)

  Dir.foreach(folder_path) do |item|
    next if item == '.' || item == '..' || item == 'todoapp2.xcodeproj'

    item_path = File.join(folder_path, item)
    relative_path = item_path.sub("#{Dir.pwd}/", '')

    if File.directory?(item_path)
      puts "#{indent}  Creating/updating group: #{item}"
      sub_group = group.groups.find { |g| g.display_name == item } || group.new_group(item)
      sub_group.set_source_tree('SOURCE_ROOT')
      sync_folder_to_group(project, sub_group, item_path, indent + '  ')
    else
      unless existing_files.include?(relative_path)
        puts "#{indent}  Adding file: #{item}"
        file_reference = group.new_file(relative_path)
        if item.end_with?('.swift')
          target = project.targets.first
          target.add_file_references([file_reference])
          puts "#{indent}    Added Swift file to target"
        end
      end
    end
  end

  group.files.each do |file|
    unless File.exist?(file.real_path)
      puts "#{indent}  Removing file: #{file.display_name}"
      group.remove_reference(file)
    end
  end
  
  group.groups.each do |sub_group|
    unless File.exist?(sub_group.real_path)
      puts "#{indent}  Removing group: #{sub_group.display_name}"
      group.remove_reference(sub_group)
    end
  end
end

# Sync all top-level folders as groups in the main group
main_group = project.main_group

Dir.glob('*').select { |f| File.directory?(f) && !f.end_with?('.xcodeproj') }.each do |folder|
  group = main_group.find_subpath(File.basename(folder), true) || main_group.new_group(File.basename(folder))
  group.set_source_tree('SOURCE_ROOT')
  sync_folder_to_group(project, group, File.join(Dir.pwd, folder))
end

# Ensure individual Swift files at the root are added
Dir.glob('*.swift').each do |swift_file|
  unless main_group.files.map(&:path).include?(swift_file)
    main_group.new_file(File.join(Dir.pwd, swift_file))
  end
end

project.save
