class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "821e285925b4020ff005afe6431430d90cd196543fbfb95c5a6d4b9d6dcffc8b"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "906a728f38ec91e5064bbac205f984894ce74cd391ccede69753d4c2204d5b67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09df002cbf79e6ec64d1d52449ad09b17d44d07043d2608b8effcb3ae5142cb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "344e666b28a11fff87f81e912498c731fed1470bb2ddab64224293cd18241509"
    sha256 cellar: :any,                 arm64_linux:   "2b5f47a48d42b05e5792cedb4a72921f16cab32b65226ffff9cd88e97144779f"
    sha256 cellar: :any,                 x86_64_linux:  "5ca5356dbcd31c89fc001f78fd311d19566afd3ed5eddf536bceef2732a3cd6c"
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
    assert_path_exists bin/"aubr"
    assert_path_exists bin/"aubx"

    (testpath/"package.json").write('{"name":"test","version":"0.0.1"}')
    system bin/"aube", "install"
  end
end
