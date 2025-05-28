class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.34.7.tar.gz"
  sha256 "f830c146b2c5b93d0c0b94ddad03ac10d6dbf9b4eb39297bd4b914ff9076e179"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f07acd3e4d10f54b8b0efcd642b8131b8b60ed1e78185f109417266628ab045"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d19c21cb5bc1143cb42e84d434c0904b6ae38d0487abadb609bae7fdf536b2e4"
    sha256 cellar: :any_skip_relocation, ventura:       "75da3081ceca8b3cf3ed6bc4a5ccf40914447ce17f4d2d641457193282fb41fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f52768bc30c4454c471b330faf9c6101ba82f112a80763ab2523a4f9f2defb2"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end
