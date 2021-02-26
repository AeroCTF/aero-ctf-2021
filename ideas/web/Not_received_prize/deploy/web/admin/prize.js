const genEx = () => {
  const spiner = document.getElementById('spiner1')
  spiner.style.display = 'inline'
  axios.post('/api/admin/pz/ex', {})
    .then((result) => {

      if (typeof result.data.error !== 'undefined') {
        UIkit.notification({
          message: result.data.error || '',
          status: 'danger',
          pos: 'top-center',
          timeout: 5000
        });
      } else {
        const ex = document.getElementById('ex')
        ex.textContent = result.data['ex'] || '';
        spiner.style.display = 'none'
      }
    })
    .catch((error) => {
      UIkit.notification({
        message: error.message,
        status: 'danger',
        pos: 'top-center',
        timeout: 5000
      });
      console.log(error);
    });
}

btn.onclick = () => {
  const btn = document.getElementById('btn')
  const spiner2 = document.getElementById('spiner2')
  const solve = document.getElementById('solve')
  const priz = document.getElementById('priz')

  btn.disabled = true
  btn.style.background = '#FFFFFF44'
  spiner2.style.display = 'inline'

  axios.post('/api/admin/pz/check', {
      solve: _.escape(solve.value)
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

        priz.src = result.data['img'] || ''
        priz.style.display = 'inline'
      }

      btn.disabled = false
      btn.style.background = '#FFFFFF00'
      spiner2.style.display = 'none'
      genEx()
    })
    .catch((error) => {
      UIkit.notification({
        message: error.message,
        status: 'danger',
        pos: 'top-center',
        timeout: 5000
      });
      console.log(error);
      btn.disabled = false
      btn.style.background = '#FFFFFF00'
      spiner2.style.display = 'none'
    });
};

genEx()