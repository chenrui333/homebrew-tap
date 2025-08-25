class WeeklyGitSummary < Formula
  desc "跨平台 CLI 工具，用于生成 Git 提交周报，支持文本、JSON、Markdown"
  homepage "https://github.com/yinzhenyu-su/weekly-git-summary"
  url "https://registry.npmjs.org/weekly-git-summary/-/weekly-git-summary-1.1.0.tgz"
  sha256 "96397088089c164823530facece2af86c35c5b29c68ce92ea836a53e6c5f006a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebd5212ee4eb80872c1d8aca99d05e0b89bc2b19f6936b4396fe6876c0268c72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7bb29e10f2e0672e08e04ef126e3e0cb310ac206d4b194bd9b00ba57ee40df1"
    sha256 cellar: :any_skip_relocation, ventura:       "51b1558005654635cb6c173468ad5042affb815011c7822ff3531f5f7aae5a0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "109b75560957e21c58cc476ec5507aece2676b285788ca8ce02c7abd332550f5"
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
