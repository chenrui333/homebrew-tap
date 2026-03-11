class Xfr < Formula
  desc "Modern iperf3 alternative with a live TUI"
  homepage "https://github.com/lance0/xfr"
  url "https://github.com/lance0/xfr/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "3ebc6f7c97d01f81f4c1b978bfe3cddaf60015b7a0a8e00719a1dd010f5c9bec"
  license "MIT"
  head "https://github.com/lance0/xfr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17d4e5640e4219af6e65d85a7233076fd1af94c2388059c429b2c367a8ff5976"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "717ab5b9734b6ee76b56678792fff4f02504dd77b91d30e85d91c38a85b81774"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfd3f78c7c44a5509472b2baa3b1dbe12f9d24435ad0f5375acc76e6040fb50d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a82bd0ec001de82ddd0bc1e5fc2ace4bf7522725fe20589bc25cc147c394b6a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af3dd5bd61ff711ec8585349548c7ea3aadcbf27a652a6599034aa971ae3a88a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"xfr", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xfr --version")
  end
end
