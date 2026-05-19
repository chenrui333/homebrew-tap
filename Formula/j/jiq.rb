class Jiq < Formula
  desc "Interactive JSON query tool with real-time output and AI assistance"
  homepage "https://github.com/bellicose100xp/jiq"
  url "https://github.com/bellicose100xp/jiq/archive/refs/tags/v3.22.3.tar.gz"
  sha256 "258c34b1a3945584e80e0d4c697248c4c1003fe630e674f9fa5ed9d6829c7048"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0de4d34ab0bf14e3636b3102ef67baf51254113d334268d02970b80f0cce548"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2674fb7fa734f917438d5d12dcbb44d3846293978bdf347afb0ab43f2a5d0c4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df5416a00be6482dc96f9911bcbd031e5f20c388766db6cbfca9aafbbe704328"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0982a2904c91a727a51ce96e1c0e7e865e1194f61667cce8b850d4df912deff6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9b57737db789cb15a3d226d218fc81e89fcac31795a82b205a07a1af033e09e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jiq --version")

    (testpath/"data.json").write("{}\n")
    empty_path = testpath/"empty"
    empty_path.mkpath
    output = shell_output("PATH=#{empty_path} #{bin}/jiq #{testpath}/data.json 2>&1", 1)
    assert_match "jq binary not found in PATH.", output
  end
end
