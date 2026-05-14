class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "f2169e0945d05db6491712e35005e26b460efd339b6bb573a7c74cc0d3c9c832"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3889ba8152a0a3219f0f68c1dd6d35c7a503ec445ffff830127a60b15f63ad5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "085ef48fe112f60a57a5be09c0c8534a66ec55f32f0a130b9c324837080a6cb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91415723e8927815ddc13837bd4a4170e8d35e7277ab592f141f40790c3c083a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71480c110b6fcc06d2d74cd11de45e53462d4d577dea0f5d0b5c6bb8b8cfd193"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e9d930654d62f804ce57f736c4fe6e29263f8798390f35fb4d29d6300966498"
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
