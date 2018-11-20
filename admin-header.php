/* file_get_contents — Transmite un fichero completo a una cadena. 
Obtención de los metadatos de instancias de AWS */

<div style="background-color:black;color:white;font-size:1.5em;text-align:center;padding:5px;width:100%">
<?php echo file_get_contents("http://169.254.169.254/latest/meta-data/local-ipv4"); ?>
<br />
<?php echo file_get_contents("http://169.254.169.254/latest/meta-data/instance-id"); ?>
</div>
