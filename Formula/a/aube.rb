class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "89828287276193bcfee0a7f5552f46c2397a62a87dbc0fa5511da5b3156aee77"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5399722bff88a67a56f65ab0ae92da3a931906e3762b46ef72c48290d140822b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d007bc51cf5f2f711efe5492bd1af420df99f38e9985ca80d0259e458914ed7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09860a18960441c0c4b699083a04785148c8e61073843fc8e24afaf4135d9f70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1fd3cfa82ca399ffb7c6d0bd87d1ba4e8065244e6746211a13c72c8112e9313"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85d3820170f2f66fcc8caf3454526abb8d3a67d3472e1ba1d27e36654ead54f8"
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
