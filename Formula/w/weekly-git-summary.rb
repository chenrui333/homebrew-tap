class WeeklyGitSummary < Formula
  desc "跨平台 CLI 工具，用于生成 Git 提交周报，支持文本、JSON、Markdown"
  homepage "https://github.com/yinzhenyu-su/weekly-git-summary"
  url "https://registry.npmjs.org/weekly-git-summary/-/weekly-git-summary-1.2.0.tgz"
  sha256 "681860b996949f498a934789004a24afdae5698cc8c57a9384d68ed35fc0a493"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "144205a48b5a00682e96bd517adbbb616de6540532f4a49ab7fa18d9086a8d9a"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/weekly-git-summary --version")
    assert_match "工作内容Git提交记录汇总", shell_output(bin/"weekly-git-summary")
  end
end
