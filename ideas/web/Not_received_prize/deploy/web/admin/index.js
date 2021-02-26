btn.onclick = () => {
  const button = document.getElementById('btn')
  const spiner = document.getElementById('spiner')

  const login = document.getElementById('login')
  const password = document.getElementById('password')

  button.disabled = true
  button.style.background = '#FFFFFF44'
  spiner.style.display = 'inline'

  axios.post('/api/auth/', {
      login: _.escape(login.value),
      password: _.escape(password.value),
      action: 'auth'
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

        login.value = '';
        password.value = '';
        setTimeout(() => { document.location.href = '/admin/list.html' }, 1000);
      }

      button.disabled = false
      button.style.background = '#FFFFFF00'
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
      button.disabled = false
      button.style.background = '#FFFFFF00'
      spiner.style.display = 'none'
    });
};