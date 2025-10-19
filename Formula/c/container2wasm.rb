class Container2wasm < Formula
  desc "Container to WASM converter"
  homepage "https://ktock.github.io/container2wasm-demo/"
  url "https://github.com/container2wasm/container2wasm/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "8e67b5e0d204ecf6ed2cf5e7abbd4dfe8e606568f1980193e5048aed0dd8c376"
  license "Apache-2.0"
  revision 1
  head "https://github.com/container2wasm/container2wasm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb64e04faef8fce74b1a4391199fee833e126444e7758611959434c41714cb74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb64e04faef8fce74b1a4391199fee833e126444e7758611959434c41714cb74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb64e04faef8fce74b1a4391199fee833e126444e7758611959434c41714cb74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31c85d8c8a563cdde65dfaa2d87ecc784d0e7770f45d4edd30b881087325578b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b24e08dd08edfc4c809cd9d1670ba080182e396ece7e6c31d4934bf4e825f566"
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
