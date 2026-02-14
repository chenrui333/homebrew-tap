class Codstts < Formula
  desc "Code statistics tool for analyzing project language distribution"
  homepage "https://github.com/zheng0116/codstts"
  url "https://github.com/zheng0116/codstts/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "31e6b46b8f43a52a4b036d07b50ea7faa11f562c01582ecda6d861679ca3f3d8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98935bad70aeabb8606678aab3723c35f071ea66a3c062df783a7f775cf0f63a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e4c08ffa0b7cd44ef9307dd36333f2737962efe2cca8f4d7b5d2b14a90ff5e5"
    sha256 cellar: :any_skip_relocation, ventura:       "f02832aeeed7f398ffc43e2487930864b41e5c9e5e4f67b80da7767dbc8efa55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "723f67509c64841ae553fa29c1a3c535247b05c1e711cad7c9150130c791d843"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codstts --version")

    testpath_dir = testpath/"test_project"
    testpath_dir.mkpath

    (testpath_dir/"test.py").write <<~PYTHON
      def hello():
          print("Hello, World!")

      hello()
    PYTHON

    (testpath_dir/"test.js").write <<~JS
      // JavaScript test file
      function greet() {
        console.log('Hello from JS');
      }

      greet();
    JS

    output = shell_output("#{bin}/codstts #{testpath_dir}")
    assert_match "Python", output
    assert_match "JavaScript", output
  end
end
