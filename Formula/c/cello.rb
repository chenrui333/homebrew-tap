class Cello < Formula
  desc "Service for running infrastructure as code software tools"
  homepage "https://github.com/cello-proj/cello"
  url "https://github.com/cello-proj/cello/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "77975a0b69e99ce6d71f5d7356ce5720ab35e81c86f3e491c36a1a0640db1205"
  license "Apache-2.0"
  revision 1
  head "https://github.com/cello-proj/cello.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3c7c09b99403fb95ba98e3eeb3eb09f719fabc3225c5aec54dd0804eb50189f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3c7c09b99403fb95ba98e3eeb3eb09f719fabc3225c5aec54dd0804eb50189f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3c7c09b99403fb95ba98e3eeb3eb09f719fabc3225c5aec54dd0804eb50189f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b3ed97c645261541502fec11ff776c8ab00c07aad189f3f79484fa9d749fc06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a860b8cc911586c1497f560295e71f0f8e1553b4d89cf76c43f19c81ad5d900"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cli"

    generate_completions_from_executable(bin/"cello", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cello version")

    output = shell_output("#{bin}/cello list --project_name test --target_name test 2>&1", 1)
    assert_match "connection refused", output
  end
end
