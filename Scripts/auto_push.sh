# Last Update: 2018-02-07
# Author: Gloomy Sunday

Tag_Version="$1"

if [${Tag_Version} = ""]; then 
	echo "You Need Input A Tag Version"
	exit 1
else
	echo "\nSubmit Verson: ${Tag_Version}\n"
	File_Path=`echo $(cd .. && pwd)`
	Code_Path="${File_Path}/Example/Pods"
	Module_File=`find $File_Path -name *.podspec`
	Module_Name="${Module_File##*/}"
	Module_Name="${Module_Name%.*}"
	

	# 1.更新 jazzy documents

	# echo "Begin Generate jazzy Document....\n"
	# echo $(cd ${Code_Path}; jazzy -c -a Gloomy.Sunday -u https://github.com/GloomySunday049 -g https://github.com/orgs/Sky-And-Hammer -o ${File_Path}/docs --min-acl internal)
	# echo "\nGit Commit For Document Updated "
	# echo $(cd ${File_Path};git add .; git commit -m "Updated: code documents updated")

	# # 2.更新 .podspec 版本号
	# echo "\nBegin Update Podspec Version...."
	# echo $(sed -i "" "s/s.version          = '0.6.1'/s.version          = '${Tag_Version}'/g" ${Module_File})
	# echo "\nGit Commit For Podspec Updated"
	# echo $(cd ${File_Path};git add .; git commit -m "Updated: Podspec Version Updated")



	# 3.GIT PUSH & GIT TAG PUSH
	echo "\nGit Push...."
	echo $(cd ${File_Path}; git push)
	echo "\nAdd Tag...."
	echo $(cd ${File_Path};git tag -a ${Tag_Version} -m 'Release Version For Cocoapods')	
	echo "\nGit Push Tag...."
	echo $(cd ${File_Path}; git push origin ${Tag_Version})

	# 4. Thunk to Cocoapods 
	ehco "\n Cocoapods Push..."
	echo $(cd ${File_Path}; pod trunk push --verbose ${Module_File})

	echo "\nSuccess...."
fi