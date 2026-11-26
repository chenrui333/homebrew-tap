class Codstts < Formula
  desc "Code statistics tool for analyzing project language distribution"
  homepage "https://github.com/zheng0116/codstts"
  url "https://static.crates.io/crates/codstts/codstts-0.1.0.crate"
  sha256 "bd9f9113cb1b8e4c40837a9a81aaf860f9598ab16875b46fa8ca3f3ec8b6130b"
  license "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "bf91809a7f2608131181b67d7cb17db21fd3cf444d7f6ccb020293c6b703d3d6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc127af1940ec3fd5a4d7ddfe5989f5d3f5caa35caaeec2be087ccf6a5a53468"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3972e5ee3f51484b91763af22cd9635e8ee26c8d9fddf4a1c8e39a7d595b0a3"
    sha256 cellar: :any,                 arm64_linux:   "09d5abbb0890f854bc7880952e9f754d9ff50ea4dbcd57adbb51cd7bc44fc0cf"
    sha256 cellar: :any,                 x86_64_linux:  "0d41163dd7980b4ec17c22a86fd1f9dd5f64e076d64afae3633e9321448bae65"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
