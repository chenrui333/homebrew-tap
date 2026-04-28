class WeeklyGitSummary < Formula
  desc "跨平台 CLI 工具，用于生成 Git 提交周报，支持文本、JSON、Markdown"
  homepage "https://github.com/yinzhenyu-su/weekly-git-summary"
  url "https://registry.npmjs.org/weekly-git-summary/-/weekly-git-summary-1.1.0.tgz"
  sha256 "96397088089c164823530facece2af86c35c5b29c68ce92ea836a53e6c5f006a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3d0c93850e0ba598c50b0dd7b8a383d079938ac7faa052f5b588ca7e7d02197"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b21c90da4386dcf3bb2c6922d5627787b7014432f6b71ed7f2ce6108374252b"
    sha256 cellar: :any_skip_relocation, ventura:       "9d2f46dea0eb67ffd87d529b5c0ab11a0e85363e6df6b269ec348d1246bb8e08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20900f483b3a3d5953ef1ffbe93421c4ef0b5c3eb7f3979f885128d4cbe492a2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/weekly-git-summary --version")
    assert_match "工作内容Git提交记录汇总", shell_output("#{bin}/weekly-git-summary")
  end
end
