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

infiniteScroll();
