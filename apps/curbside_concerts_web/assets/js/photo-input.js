const onRemove = () => {
  const current = document.getElementById("current-image");
  const newImage = document.getElementById("new-image");
  const hiddenMusicainPhoto = document.getElementById("hidden-musician-photo");
  const uploader = document.getElementById("musician_photo");

  if(current) {
    current.hidden = true;
  }
  newImage.hidden = false;
  uploader.value = "";
  if(hiddenMusicainPhoto) {
    hiddenMusicainPhoto.remove();
  }
  return false;
}

const remove = document.getElementById("remove-image");

if(remove) {
  remove.onclick = onRemove
}