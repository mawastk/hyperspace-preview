![Logo](https://github.com/mawastk/hyperspace-preview/blob/main/image/build/logo_2.png?raw=true)

Please note: This text has been translated from Japanese. You can also read the original readme in its original language.<br>
（日本語版はこちらです）

# Hyperspace-preview
A level editor for Smash Hit that runs on Android

# How to install
Please install Hyperspace, HyperspaceExporter, and HyperspaceTester on your Android device.

To use all three apps, your device must be running Android 5.1 or later.
(Issues may occur on Android 11 or later)

| App | Supported Versions |
|:-----------|:------------:|
| Hyperspace       | Android 4.4.4 ~          |
| HyperspaceExporter     | Android 5.1 ~       |
| HyperspaceTester       | Android 2.3 ~         |

Once the installation is complete, please add the template XML file used for mesh baking to
/storage/emulated/0/Android/data/com.mawario.hyerspaceexporter/files/template.xml
(To ensure compatibility with Android 11 and later devices, this process is automated in the full version.)

Once setup is complete, tap Hyperspace (the purple/pink icon) to start using it.

# How do I export this?

Currently, the export UI only allows you to export uncompressed XML files that do not contain meshes.

However, running a quick test will generate .xml.gz and .mesh files in the following directory:
/storage/emulated/0/Android/data/com.mawario.hyerspaceexporter/files/

# It's not working :(
If it doesn't work properly, please check the following:

This will not work if the segment file is named .xml.mp3. Please do not add the .mp3 extension; use only .xml.

If HyperspaceTester freezes when you press Play, try pressing Play immediately after exporting; it might work.

If mesh baking isn't working in HyperspaceExporter, try switching your keyboard app to Gboard. The app uses the clipboard to share XML files from the editor to the Exporter.

# More technical troubleshooting

If MeshbakerChan appears in Exporter but the segments are not exporting properly, please check the text in the clipboard. If the last two characters are not “∞f”, the segment size is too large to export.

When creating segments, aim to keep the XML file under 18,000 characters.

# Tools Used

knshim by [knot126](https://codeberg.org/knot126)<br>
MeshBake by [knot126](https://codeberg.org/knot126)
