<?php
/******************************************
Plugin Name: online visitors
Description: Display the amount of users currently visiting your website
Version: 1.1 - Jul.2012
Author: Wojciech Jodła
Author website: http://www.wujitsu.pl/
Credits: visitors online plugin incorporates some code snippets from http://www.coursesweb.net/ script
		 management functions used in this plugin base on code from breadcrumbs plugin, 
		 developed by http://www.webmasterdubai.com/

*******************************************

Installation and usage: 
1. Unzip and upload plugin's files into /plugins directory
2. configure the plugin under plugins > online visitors tab
3. call the function responsible for showing the counter by pasting below code in your template file:
	<?php visitors_online(); ?>

	and that's all you need to do.

4. you can also stylize the look of counter's label and its digits in the way you want.
Just add below code to your css file and stylize it, otherwise counter will inherit styles for h6 element.

h6#usersonline { /* counter's label & digit styles 
	...
}
h6#usersonline span { /* counter's digit styles 
	...
}

********************************************/

# get correct id for plugin
$thisfile=basename(__FILE__, ".php");

# register plugin
register_plugin(
	$thisfile, 
	'Online Visitors', 	
	'1.0', 		
	'Wojciech Jodla - www.WuJitsu.pl',
	'http://www.wujitsu.pl/', 
	'Display the amount of users currently visiting your website.',
	'plugins',
	'visitors_online_setup'  
);

$visitors_online_folder_name = 'online_visitors';
$visitors_online_folder_name_folder_path = GSPLUGINPATH.$visitors_online_folder_name.'/';
$visitors_online_settings_file = $visitors_online_folder_name_folder_path.'online_visitors_settings.xml';

add_action('plugins-sidebar','createSideMenu',array($thisfile,'Online visitors'));

function visitors_online_setup(){
    global $visitors_online_settings_file;
    if (isset($_POST['time']) && isset($_POST['label'])){
        $xml = @new SimpleXMLExtended('<?xml version="1.0" encoding="UTF-8"?><item></item>');

        $note = $xml->addChild('online_visitors_time');
        $note->addCData($_POST['time']);
        $note = $xml->addChild('online_visitors_label');
        $note->addCData($_POST['label']);

        $xml->asXML($visitors_online_settings_file);

        visitors_online_msg_box('Online Visitors settings Saved Successfully!');

    }
    elseif(!isset($_POST['time']) && $_POST)
        visitors_online_msg_box('<strong>Error:</strong> You cannot save an empty time.',true);
    elseif(!isset($_POST['label']) && $_POST)
        visitors_online_msg_box('<strong>Error:</strong> You cannot save an empty label.',true);
    $setting_value = get_visitors_online_settings();
    
?>
<label>Visitors Online - settings</label> <br/>
<p style="padding-left:10px">Set the time in which visits will be counted and shown on your website.<br>
By leaving default value of <b>10</b>, plugin will show amount of visitors from last 10 minutes.<br>
You can also change counter's label to your native language.
</p>
<form method="post" action="<?php echo $_SERVER ['REQUEST_URI']?>">
<table class="highlight" id="OnlineVisitorsTable">
    <tr>
        <td>Time</td>
        <td><input type="text" name="time" value="<?php echo $setting_value['time'];?>" /> <small>(in minutes)</small></td>
    </tr>
    <tr>
        <td>Label</td>
        <td><input type="text" name="label" value="<?php echo $setting_value['label'];?>" /> </td>
    </tr>
</table>
    <input type="submit" name="submit" class="submit" value="Save Settings" />
</form>
<?php
}  

 function get_visitors_online_settings() {
   global $visitors_online_settings_file;

    $visitors_online_settings = array();
    if (file_exists($visitors_online_settings_file)) {
        $v = getXML($visitors_online_settings_file);
        $visitors_online_settings['time'] = $v->online_visitors_time;
        $visitors_online_settings['label'] = $v->online_visitors_label;
    }

    return $visitors_online_settings;
}

/**  
Generate a message box 
**/
if (!function_exists('visitors_online_msg_box'))
{
	function visitors_online_msg_box($msg,$error = false)
	{
            if($error)
                echo '<div class="error">'.$msg.'</div>';
            else
		echo '<div class="updated" >
				'.$msg.'
			 </div>';
	}
}
/**  
count and display visitors
**/
function visitors_online() {
if(!isset($_SESSION)) session_start();        // start Session, if not already started
$visitorslist = GSDATAOTHERPATH."visitors_online.txt"; // file storing online visitors
$settings_value = get_visitors_online_settings();
$timeon = 60 * (int)$settings_value['time'];  // session time to store visits; format in minutes thaken from admin panel
$userseparator = ' | ';               // characters used to separate user ID and date-time
$visitoruniqueID = $_SERVER['REMOTE_ADDR'] .' - '. $_SERVER['HTTP_USER_AGENT']; // visitors are being count by their IP, and browser they use
$rgxvst = '/^([0-9\.]*)/i';         // regexp to recognize the line with visitors
$nrvst = 0;                        	// store the number of visitors
// sets the row with the current user /visitor that must be added in $visitorslist (and current timestamp)
$addrow[] = $visitoruniqueID. $userseparator. time();

// check if the file from $visitorslist exists and is writable
if(is_writable($visitorslist)) {
  // get into an array the lines added in $visitorslist
  $ar_rows = file($visitorslist, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
  $rowsnumber = count($ar_rows);  // number of rows 
  // if there is at least one line, parse the $ar_rows array
  if($rowsnumber>0) {
    for($i=0; $i<$rowsnumber; $i++) {
      // get each line and separate the user /visitor and the timestamp
      $ar_line = explode($userseparator, $ar_rows[$i]);
      // add in $addrow array the records in last $timeon seconds
      if($ar_line[0]!=$visitoruniqueID && (intval($ar_line[1])+$timeon)>=time()) {
        $addrow[] = $ar_rows[$i];
      }
    }
  }
}
$totalvisitors = count($addrow);   // total online
// traverse $addrow to get the number of visitors and users
for($i=0; $i<$totalvisitors; $i++) {
 if(preg_match($rgxvst, $addrow[$i])) $nrvst++;       // increment the visitors
}
$displayviscounter = '<h6 id="usersonline">'.$settings_value['label'].': <span>' . $totalvisitors. '</span></h6>';// HTML code with data to be displayed
// write data in $visitorslist
if(!file_put_contents($visitorslist, implode("\n", $addrow))) $displayviscounter = 'Error: visitors data file does not exist, or is not writable!';

echo $displayviscounter;             // display the result
}
?>