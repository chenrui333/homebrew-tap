class WeeklyGitSummary < Formula
  desc "跨平台 CLI 工具，用于生成 Git 提交周报，支持文本、JSON、Markdown"
  homepage "https://github.com/yinzhenyu-su/weekly-git-summary"
  url "https://registry.npmjs.org/weekly-git-summary/-/weekly-git-summary-1.0.5.tgz"
  sha256 "48d0a75c559f8bd425e18bd30304e5fa8621d393f2efedb892039b299552cd0e"
  license "MIT"

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
