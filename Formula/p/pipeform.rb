class Pipeform < Formula
  desc "Terraform runtime TUI"
  homepage "https://github.com/magodo/pipeform"
  url "https://github.com/magodo/pipeform/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "0b251f3d0d259b0e3d15b08b95567f3eef123afae9c3d0e20107cd6f08aa6278"
  license "MPL-2.0"
  head "https://github.com/magodo/pipeform.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # TODO: need a better test to test pipe
    system bin/"pipeform", "--help"
  end
end
