btn.onclick = () => {
  const button = document.getElementById('btn')
  const spiner = document.getElementById('spiner')

  const name = document.getElementById('name')
  const msg = document.getElementById('msg')
  const captch = document.getElementById('g-recaptcha-response')

  button.disabled = true
  button.style.background = '#FFFFFF44'
  spiner.style.display = 'inline'

  axios.post('/api/help/add', {
      name: _.escape(name.value),
      msg: _.escape(msg.value),
      captch: _.escape(captch.value)
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
          message: `${result.data.status || ''}<br><a href="/help/read.html?id=${result.data.id || ''}">View</a>`,
          status: 'primary',
          pos: 'top-center',
          timeout: 7000
        });

      }

      grecaptcha.reset()

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


function onSubmit(token) {
  document.getElementById("demo-form").submit();
}