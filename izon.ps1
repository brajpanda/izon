function ConvertFromJson-Izon([object] $data) {
  add-type -assembly system.web.extensions
  $serializer=new-object system.web.script.serialization.javascriptSerializer
  return New-Object PSObject -Property $serializer.DeserializeObject($data)
}

function ReadVersion-Izon() {
  $data=Get-Content -Raw "$Env:TEMP\version.json"
  return ConvertFromJson-Izon($data)
}

function ReadDependencies-Izon() {
  $dependencies=ReadVersion-Izon | Select -ExpandProperty dependencies
  return New-Object PSObject -Property $dependencies
}

function ReadDependency-Izon([object] $dependency) {
  return ReadDependencies-Izon | Select -ExpandProperty $dependency | %{ $_ -split "#" }
}
