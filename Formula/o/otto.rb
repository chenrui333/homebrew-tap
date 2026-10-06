class Otto < Formula
  desc "JavaScript interpreter in Go (golang)"
  homepage "https://github.com/robertkrimen/otto"
  url "https://github.com/robertkrimen/otto/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "8b9bcc75b86fed76eb0aa981dd470c3911144699d17efe5d7d94f085fc032c37"
  license "MIT"
  head "https://github.com/robertkrimen/otto.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22569de3e1e4270947220cf9d39ee635a88bc87a04f887facbce1b504a0baf73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22569de3e1e4270947220cf9d39ee635a88bc87a04f887facbce1b504a0baf73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed2740b220414084f776d45374dd6cbcc9b8af7d50ab55708dae28c96a9ccccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1365c564af66e239e2d9c31d5fb0857a9d993bb0f4abe7b5a494f64fdd242895"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./otto"
  end

  test do
    (testpath/"test.js").write <<~JS
      console.log("Hello from Otto!");
    JS

    assert_match "Hello from Otto!", shell_output("#{bin}/otto test.js")
  end
end
