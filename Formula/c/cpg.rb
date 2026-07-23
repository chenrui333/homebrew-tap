class Cpg < Formula
  desc "Cilium Policy Generator using Hubble relay"
  homepage "https://github.com/SoulKyu/cpg"
  url "https://github.com/SoulKyu/cpg/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "e6ed68f38da4b4c6126b969c28602e7c81736ebe4d124c0bd822c49e8f14a434"
  license "Apache-2.0"
  head "https://github.com/SoulKyu/cpg.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72f947e34e28156e0abe2bac1fbc3f96cf2a5feac73dff342f7622d5ee2cd524"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ab1fe7ea35566e55aee264245015e9f108fd2a32f7196e79b0dfa96cade4f47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18237e27f776f5e00ba7a8688817e5097f2549a2d6124eaf9d1e0ced94d46a4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67f3db62042c3105ab5f29dcae145e5ef2be0f8f59def5eda5c6700481aa3d68"
    sha256 cellar: :any,                 x86_64_linux:  "c9b79efb0b90099afe5cccafeab893e3d42af85532cf2014aeacc8bea77505ab"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/cpg"

    generate_completions_from_executable(bin/"cpg", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cpg --version")
  end
end
