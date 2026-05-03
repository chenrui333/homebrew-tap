class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "27ce0fa92fc59922cd5a92d6086c8d312e2de0afad35a3f02d0594cd88250e71"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f27d20fc2fa6234becc892ad27ff3e87090a20c6ad1430075514167128acb379"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb6008a5a03fb39738e427da567588c36392e37d9fa6a57fbf7c3e37af127112"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d64c439c6460c884392644e2224a578ea6d2cffe687df9e1ab024ac021106e22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4058a837b5011cd4b16fc6c633499660b33fa56860ad3274ea140b3892c21aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f45d47001b3055a7c3684c1e64bdcaffb3f399ababcb4cf0c2c17feb965eebf5"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "usage" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/aube")

    generate_completions_from_executable(bin/"aube", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aube --version")
    assert_match "Usage", shell_output("#{bin}/aubr --help")
    assert_match "Usage", shell_output("#{bin}/aubx --help")

    (testpath/"package.json").write('{"name":"test","version":"0.0.1"}')
    system bin/"aube", "install"
  end
end
