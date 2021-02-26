btnLogOut.onclick = () => {
  const btnLogOut = document.getElementById('btnLogOut')
  const spiner = document.getElementById('spiner')

  btnLogOut.disabled = true
  btnLogOut.style.background = '#FFFFFF44'
  spiner.style.display = 'inline'

  axios.post('/api/auth/', {
      action: 'logout'
    })
    .then((result) => {

      if (typeof result.data.error !== 'undefined') {
        UIkit.notification({
          message: result.data.error || '',
          status: 'danger',
          pos: 'top-center',
          timeout: 5000
        });
      } else {

        UIkit.notification({
          message: result.data.status || '',
          status: 'primary',
          pos: 'top-center',
          timeout: 5000
        });
        setTimeout(() => { document.location.href = '/admin/index.html' }, 1000);
      }

      btnLogOut.disabled = false
      btnLogOut.style.background = '#FFFFFF00'
      spiner.style.display = 'none'
    })
    .catch((error) => {
      UIkit.notification({
        message: error.message,
        status: 'danger',
        pos: 'top-center',
        timeout: 5000
      });
      console.log(error);
      btnLogOut.disabled = false
      btnLogOut.style.background = '#FFFFFF00'
      spiner.style.display = 'none'
    });
};