# framework: bubbletea
class Pipeform < Formula
  desc "Terraform runtime TUI"
  homepage "https://github.com/magodo/pipeform"
  url "https://github.com/magodo/pipeform/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "0b251f3d0d259b0e3d15b08b95567f3eef123afae9c3d0e20107cd6f08aa6278"
  license "MPL-2.0"
  head "https://github.com/magodo/pipeform.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66a1e19a6fd7d98df503e453199eeb6dd87782e678a31ae6edc68ae8888ca5b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edec7c60e03c7282e12f3d06e0e0f5f6fab8c34a44c12bc773e60b99fa45711e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71883159fc8e87d95e5de139b6778a1aecd841d68d0fcea86f39b2a8f2a5fb84"
    sha256 cellar: :any,                 x86_64_linux:  "089d9eff0bb80df31a3947c4e8b5e49aeb7c35c93d1fc9e92d7332d4f9e5fc8c"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "libx11" => :build # headers for golang.design/x/clipboard (dlopens libX11 at runtime)
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    stream = <<~JSON
      {"@level":"info","@message":"Terraform will perform the following actions:"}
      {"@level":"info","@message":"Plan: 1 to add, 0 to change, 0 to destroy."}
    JSON

    tee_path = testpath/"output.jsonl"
    pipe_output("#{bin}/pipeform --plain-ui --tee #{tee_path}", stream, 1)
    assert_match "Terraform will perform", tee_path.read
  end
end
