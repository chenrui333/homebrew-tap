class Gitsocial < Formula
  desc "Git-native cross-forge collaboration platform"
  homepage "https://github.com/gitsocial-org/gitsocial"
  url "https://github.com/gitsocial-org/gitsocial/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "dc2de88e77ef161cb4aa8f19eaa87c8bc9bc83dea0a3c961aa413e5250d6c87e"
  license "MIT"
  head "https://github.com/gitsocial-org/gitsocial.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae746fb2392885f250689af04f9d25b2384f0fa4d221c2b74d099bb8f56a8b82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae746fb2392885f250689af04f9d25b2384f0fa4d221c2b74d099bb8f56a8b82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae746fb2392885f250689af04f9d25b2384f0fa4d221c2b74d099bb8f56a8b82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "131910c53df5dcb3a59d7003fa37b642cb28ce76873006328055c8ba026021e6"
    sha256 cellar: :any,                 x86_64_linux:  "bf1f8cec873635c2c33993837311f56326aaf16d7652a2c91dc9a900e5f684aa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cli/gitsocial"

    generate_completions_from_executable(bin/"gitsocial", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitsocial --version 2>&1")
  end
end
