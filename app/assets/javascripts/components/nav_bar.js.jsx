var NavBar = React.createClass({
  render: function () {
    return(
      <nav id="fh5co-main-menu" role="navigation">
        <ul>
          <li className="f5hco-active"><a href="/">HOME</a></li>
          <li className="f5hco-active"><a href="/welcome/how_to">INSTRUCTIONS</a></li>
          <li className="f5hco-active"><a href="/welcome/terms">TERMS</a></li>
          <li className="f5hco-active"><a href="/welcome/faq">FAQ</a></li>
          <li className="f5hco-active"><a href="/users/sign_in">LOGIN</a></li>
        </ul>
      </nav>
    )
  }
});