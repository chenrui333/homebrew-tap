class Autotag < Formula
  desc "Git repository version tagging tool"
  homepage "https://github.com/autotag-dev/autotag"
  url "https://github.com/autotag-dev/autotag/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "71d6f082efa5c641461f603c16b50c1d3e4aae2cdd5f550b912efb5051043a99"
  license "Apache-2.0"
  revision 1
  head "https://github.com/autotag-dev/autotag.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "932b7c4f012f7adcf47e498b87cda96af6a80600981e2b1f3847033eb7f047cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "932b7c4f012f7adcf47e498b87cda96af6a80600981e2b1f3847033eb7f047cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "932b7c4f012f7adcf47e498b87cda96af6a80600981e2b1f3847033eb7f047cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df43dc7a4c414353b32d05b7d4c4888a67d80128ed3f9dd96267c17418ac429b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d883d547f33402d93f0fc414b74402303eb479aabfc494e6e4dfa4f0da0f5515"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./autotag"
  end

  test do
    system "git", "init", "--initial-branch=main"
    system "git", "commit", "--allow-empty", "-m", "invalid"
    output = shell_output("#{bin}/autotag version 2>&1", 1)
    assert_match "no stable (non pre-release) version tags found", output
  end
end
