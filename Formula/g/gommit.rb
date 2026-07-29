class Gommit < Formula
  desc "Enforce git message commit consistency"
  homepage "https://github.com/antham/gommit"
  url "https://github.com/antham/gommit/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "8050eaef69f5729bd9000855859a60b7d6403db30d1e9ca7776034428ab1e873"
  license "Apache-2.0"
  head "https://github.com/antham/gommit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "448ce47b3e7ff507f3056f7a60855302bc39d8138e7463cb480ba550277eda9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "448ce47b3e7ff507f3056f7a60855302bc39d8138e7463cb480ba550277eda9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "448ce47b3e7ff507f3056f7a60855302bc39d8138e7463cb480ba550277eda9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b651e8e56d190f8c5d8d81aad0116fc71cdd10fcd0f5357b383bca8724610a23"
    sha256 cellar: :any,                 x86_64_linux:  "e1c1738e17dfa463e232004480e92e8d18a514bc41c4bcac0b81b20bf4a587fa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X gommit.appVersion=#{version}")

    generate_completions_from_executable(bin/"gommit", shell_parameter_format: :cobra)
  end

  test do
    (testpath/".gommit.toml").write <<~TOML
      [config]
      exclude-merge-commits=true
      check-summary-length=true
      summary-length=72
    TOML

    system bin/"gommit", "check"

    system bin/"gommit", "version"
  end
end
