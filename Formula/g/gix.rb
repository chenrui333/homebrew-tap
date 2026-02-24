class Gix < Formula
  desc "Git, but with superpowers"
  homepage "https://github.com/ademajagon/gix"
  url "https://github.com/ademajagon/gix/archive/refs/tags/v0.2.10.tar.gz"
  sha256 "bcabb53c87e1a5c0de42027be0d2af2c6b3563f7eb5be61870f089874b5b3a81"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b9696a7ad59c0f931bf81884a2ec94e053002f32c8ffb4eb40e5e850e95662c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b9696a7ad59c0f931bf81884a2ec94e053002f32c8ffb4eb40e5e850e95662c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b9696a7ad59c0f931bf81884a2ec94e053002f32c8ffb4eb40e5e850e95662c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f455573a16ab19a1ee27918031f32d44afef6c8c131bd85e7c3ee5cbb776db3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c913301779501ba08e79ab7ae40a3759ae713b829e0f47efc751d28adebcb36a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/ademajagon/gix/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gix", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gix --version")

    (testpath/"test.txt").write("Hello World!")
    system "git", "init"
    system "git", "add", "test.txt"

    output = shell_output("#{bin}/gix commit 2>&1", 1)
    assert_match "config not found - run `gix config set-key`", output
  end
end
