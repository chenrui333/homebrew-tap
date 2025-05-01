class Container2wasm < Formula
  desc "Container to WASM converter"
  homepage "https://ktock.github.io/container2wasm-demo/"
  url "https://github.com/container2wasm/container2wasm/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "046e29b9dcb0fc8fc3bca8a5b0534b5f3a71c60bd5e1801cd2edf5cf914e511a"
  license "Apache-2.0"
  head "https://github.com/container2wasm/container2wasm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a5ad3f130ca907ad7f23406c7a881dbd96229054cd26e0d2d035511b772665f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2792ef8f438ed655187a614c46af853ca12cde3f3c3c1100379d4e11c53f907"
    sha256 cellar: :any_skip_relocation, ventura:       "43ef08e45102e3c4a3c99564a06bf9b092299608a2ada774e53c3fe4f11852e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f558277aafcb33ab699924f45596de3e8d846c7260a0ac2e26003c185ec82c1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/ktock/container2wasm/version.Version=#{version}
    ]

    %w[c2w c2w-net].each do |cmd|
      system "go", "build", *std_go_args(ldflags:, output: bin/cmd), "./cmd/#{cmd}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/c2w --version")
    assert_match "FROM wasi-$TARGETARCH", shell_output("#{bin}/c2w --show-dockerfile")
  end
end
