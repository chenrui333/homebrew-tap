# framework: cobra
class Cocainate < Formula
  desc "Cross-platform caffeinate alternative"
  homepage "https://github.com/AppleGamer22/cocainate"
  url "https://github.com/AppleGamer22/cocainate/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "c49a871e30647155f064704ae39084406d0506f52f8b1362b150e1bc239950e8"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/AppleGamer22/cocainate.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1858122333b56c88843569f62fb97d5d77a0c9c5a2a40e3be573bc1084993690"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dddff36ebcd4ceddff3b962aa4d74b7911b6f43c4eb6527873a90ba55bfe3ebe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b901278fb4dac2d1721bcdf05236a475d97a754b13c64de53afebe148dc9b64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9b9f5342a3c1db03d6e79e30622dedb41685166772dbc56a7c3d16fae787241"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f92ba7af2417c9adc75128eec8e26e90f0745e428fa0acf914323480e5766ff8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/AppleGamer22/cocainate/commands.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"cocainate", shell_parameter_format: :cobra)
    (man1/"cocainate.1").write Utils.safe_popen_read(bin/"cocainate", "manual")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cocainate --version")

    # Fails in Linux CI with
    # `The name org.freedesktop.ScreenSaver was not provided by any .service files`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"cocainate", "--duration", "1s"
  end
end
