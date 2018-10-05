//= require rails-ujs
//= require_tree .

function infiniteScroll() {
  const rowCards = document.querySelector('.row');
  if (rowCards) {
    window.addEventListener('scroll', () => {
      more_posts_url = document.querySelector('.pagination .next a').href;
      console.log(more_posts_url);
    });
  }
}

ScrollReveal().reveal('.card');
// ScrollReveal().reveal('.card__heading', { delay: 500 });
// ScrollReveal().reveal('.card__description', { delay: 1000 });
// ScrollReveal().reveal('.card__subdetails', { delay: 2000 });
