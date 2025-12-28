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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe17491c148390b24e3eedd0cc70543d0b03fd72cdd754224e3ab650bcda6d7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6cafc4db3210a15a15bda790220cd44b1edb59cfe6869c3418e06f13f947c5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38cc654d1677f9098ff02ccd0b26886107c9194c40f2f2eae409056fbe06f8b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f46ffeda33d4575c04ac036164f532b2f7eb33990659d84a62d9ff9521ad53e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee93a1ffeed6f60c1166a32d697b83516cd21702d3b8f6f867bdc5b52721e6c7"
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
