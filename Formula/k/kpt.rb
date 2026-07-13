class Kpt < Formula
  desc "Automate Kubernetes Configuration Editing"
  homepage "https://kpt.dev/"
  url "https://github.com/kptdev/kpt/archive/refs/tags/v1.0.0-beta.67.tar.gz"
  sha256 "358f6dc09e0ed494432d1b669ee1a9133bc20c285defbdc495ca29994b43b424"
  license "Apache-2.0"
  head "https://github.com/kptdev/kpt.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-beta\.\d+)?)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f04ede2fb03f03de77143fa9be7669adca06faece23a5bbd8b52d1617688caa8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24774fe13f2b0d1d16c57cd5a7ce4c07793d95dd4247fa8569a8b4ee57553b09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cafe91c5fd6e17c4b28a7d6bdabc786914cfa0a91bba16615917c571205c3710"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e995dacf44461b3c012aaa72b3e64659e50eaca411a9fa5db4401478d323a6f"
    sha256 cellar: :any,                 x86_64_linux:  "3f1146444afe269d4a9c331f56bede7571636bbf59ae46a8782dd6562a87e51f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kptdev/kpt/run.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kpt", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kpt version")

    output = shell_output("#{bin}/kpt live status 2>&1", 1)
    assert_match "error: no ResourceGroup object was provided", output
  end
end
