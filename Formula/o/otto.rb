class Otto < Formula
  desc "JavaScript interpreter in Go (golang)"
  homepage "https://github.com/robertkrimen/otto"
  url "https://github.com/robertkrimen/otto/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "8b9bcc75b86fed76eb0aa981dd470c3911144699d17efe5d7d94f085fc032c37"
  license "MIT"
  head "https://github.com/robertkrimen/otto.git", branch: "master"

  depends_on "go" => :build

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
