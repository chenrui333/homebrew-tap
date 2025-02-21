class Dyff < Formula
  desc "Diff tool for YAML files, and sometimes JSON"
  homepage "https://github.com/homeport/dyff"
  url "https://github.com/homeport/dyff/archive/refs/tags/v1.9.4.tar.gz"
  sha256 "77e48f951de76636080bfe067293262a491fd7b26511b189c5c655cdb7c24516"
  license "MIT"
  head "https://github.com/homeport/dyff.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0a90059bd63996bb1d8a67657f88a9211cf251cac4d26a4b68982cf2ce843c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89bd76ad90b6700168161a175d63dfdfd0a20c8a4fc29d1ea28cbcd5486e5bb9"
    sha256 cellar: :any_skip_relocation, ventura:       "a8770365b0611f53e20704c4273c0d95b246b3b43c75e7acb72b04490a040f31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff91b89d4a686a0d150a076f14eba5e35932af3510c816315ed2682470c6d465"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/homeport/dyff/internal/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dyff"

    generate_completions_from_executable(bin/"dyff", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dyff version")

    (testpath/"file1.yaml").write <<~YAML
      name: Alice
      age: 30
    YAML

    (testpath/"file2.yaml").write <<~YAML
      name: Alice
      age: 31
    YAML

    output = shell_output("#{bin}/dyff between file1.yaml file2.yaml")
    assert_match <<~EOS, output
      age
        ± value change
          - 30
          + 31
    EOS
  end
end
