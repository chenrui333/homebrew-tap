class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "89828287276193bcfee0a7f5552f46c2397a62a87dbc0fa5511da5b3156aee77"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ff7373feaf1cf9503e56de26fe389fa1fb224bc300b695f5fb868e19065fe7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e0f2b278a0fed1fc2a2b140ca75e8847ca7a104853ddf62a3d3ef3ac24adad8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a1adcceecf1b4fecc62f249a53cdf1ed0b9e14b08a23dd50dafed9db7f91a7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f08f952d4995e3969fdd2f9f34fd4cd7bec8470be59d57583b4712e28c5719f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fa9fd3ff8f8c668f9d9fb85f7bc4524e3b8cbc6459104226c3595c54418c61a"
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
