class StacksCli < Formula
  desc "Analyze website stack from the terminal"
  homepage "https://github.com/WeiChiaChang/stacks-cli"
  url "https://registry.npmjs.org/stacks-cli/-/stacks-cli-1.0.4.tgz"
  sha256 "0eaf71b41fddea631657b1b523548d2d0aaf1b401ee360414086efb6326db379"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stacks-cli --version")

    output = shell_output("#{bin}/stacks-cli https://meetup.com")
    assert_match <<~EOS, output
      ╔════════════════════╤════════════╤═══════════════════════╤══════════════════════════════════╗
      ║ Name               │ Confidence │ Categories            │ Website                          ║
      ╟────────────────────┼────────────┼───────────────────────┼──────────────────────────────────╢
      ║ Crazy Egg          │ 100 % sure │ Analytics             │ http://crazyegg.com              ║
      ╟────────────────────┼────────────┼───────────────────────┼──────────────────────────────────╢
      ║ Google Tag Manager │ 100 % sure │ Tag managers          │ http://www.google.com/tagmanager ║
      ╟────────────────────┼────────────┼───────────────────────┼──────────────────────────────────╢
      ║ Next.js            │ 100 % sure │ Web frameworks        │ https://nextjs.org               ║
      ╟────────────────────┼────────────┼───────────────────────┼──────────────────────────────────╢
      ║ Sentry             │ 100 % sure │ Issue trackers        │ https://sentry.io/               ║
      ╟────────────────────┼────────────┼───────────────────────┼──────────────────────────────────╢
      ║ React              │ 0 % sure   │ JavaScript frameworks │ https://reactjs.org              ║
      ╟────────────────────┼────────────┼───────────────────────┼──────────────────────────────────╢
      ║ webpack            │ 0 % sure   │ Miscellaneous         │ https://webpack.js.org/          ║
      ╟────────────────────┼────────────┼───────────────────────┼──────────────────────────────────╢
      ║ Node.js            │ 0 % sure   │ Programming languages │ http://nodejs.org                ║
      ╚════════════════════╧════════════╧═══════════════════════╧══════════════════════════════════╝
    EOS
  end
end
