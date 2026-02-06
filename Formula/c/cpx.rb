class Cpx < Formula
  desc "Batteries-included Cargo-like CLI for C++"
  homepage "https://cpx-dev.vercel.app/"
  url "https://github.com/ozacod/cpx/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "133b4ae441397ca1cdf0fddb8482e2ff0c73ecc1637669cc6329e3647a3db178"
  license "MIT"
  head "https://github.com/ozacod/cpx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5049bee71cfd3f5b0cb97c14c27f9bb1bc25c6d5e82d48c3908d92643280b2b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5049bee71cfd3f5b0cb97c14c27f9bb1bc25c6d5e82d48c3908d92643280b2b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5049bee71cfd3f5b0cb97c14c27f9bb1bc25c6d5e82d48c3908d92643280b2b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c85f4a466beca221cec683a050ddf7ffdcda0f995435f43ac9ce82083211ea00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b02279ba738880ae3ccc31074df1349f5b1f380e17f05efc5e0162f60368ee58"
  end

  depends_on "go" => :build

  def install
    cd "cpx" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cpx"
    end

    generate_completions_from_executable(bin/"cpx", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cpx --version")
    assert_match "vcpkg_root not set in config", shell_output("#{bin}/cpx list 2>&1", 1)
  end
end
