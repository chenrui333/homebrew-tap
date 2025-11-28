class Ecscope < Formula
  desc "Monitor AWS ECS resources from the terminal"
  homepage "https://tools.dhruvs.space/ecscope/"
  url "https://github.com/dhth/ecscope/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "23192359513f5632ff25ce38a1ea97173a74278add0a295b39734e83f14f05c4"
  license "MIT"
  head "https://github.com/dhth/ecscope.git", branch: "main"

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
