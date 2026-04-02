class Kpt < Formula
  desc "Automate Kubernetes Configuration Editing"
  homepage "https://kpt.dev/"
  url "https://github.com/kptdev/kpt/archive/refs/tags/v1.0.0-beta.62.tar.gz"
  sha256 "1198a5f397cd96424bee681970d1c4edf299c4c583015de1a6cba8668026b28d"
  license "Apache-2.0"
  head "https://github.com/kptdev/kpt.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-beta\.\d+)?)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7decda1e649fee5adba5be4d686996cf435d2d420b73aad5185499bfd71bcb54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4118e600fcbae8d63b822d2b23ddc95541072f5a156958ea98da19edb6861f0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09769a920c3f48025c051cfee4829e3ac1590bacd5388d746eb4d8b217649940"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc865c825b48420a738b98417c23cd81acc71771b06436838c0f393af78b3ab9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a344e497e19cac1deeb248712b6e22d9ef3cbb21e0034d4a64002e46b3737ec"
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
