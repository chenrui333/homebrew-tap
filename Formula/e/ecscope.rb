class Ecscope < Formula
  desc "Monitor AWS ECS resources from the terminal"
  homepage "https://tools.dhruvs.space/ecscope/"
  url "https://github.com/dhth/ecscope/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "23192359513f5632ff25ce38a1ea97173a74278add0a295b39734e83f14f05c4"
  license "MIT"
  head "https://github.com/dhth/ecscope.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c030ce5494c3e3824d9e06e19f3f75e5874d954f352749e46581ddb1cbea726f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c87675265ae48ab7101decd5c70455c24c1739e71e6b3e26aeefdfaf257ef9b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0921b69eec60be939f08ec3e2e49d9960085d23b65b1e668fd7d2565b1a4c907"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36051d86afd99a1bd4f4809bbc6fd8c58055756a143d81fc9e7b418ea1c5f36c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "853cd4fb4237ca114f5db5bb214b702981260fca9eb6118baccd95fb7298bb66"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # no version command
    assert_match "ecscope lets you monitor AWS ECS resources from the terminal", shell_output("#{bin}/ecscope --help")

    ENV["AWS_ACCESS_KEY_ID"] = "testing"
    ENV["AWS_SECRET_ACCESS_KEY"] = "testing"

    assert_empty shell_output("#{bin}/ecscope profiles list")
  end
end
