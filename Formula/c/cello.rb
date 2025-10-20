class Cello < Formula
  desc "Service for running infrastructure as code software tools"
  homepage "https://github.com/cello-proj/cello"
  url "https://github.com/cello-proj/cello/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "7e6c0295a8fc7c1f2f4cf9bbb7fd21710da7f605bdb472162f1742246e0e33b1"
  license "Apache-2.0"
  head "https://github.com/cello-proj/cello.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b4e62660a47fb4beb137e217e60aa24a81a10084c622a21949ef877db8eada2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b4e62660a47fb4beb137e217e60aa24a81a10084c622a21949ef877db8eada2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b4e62660a47fb4beb137e217e60aa24a81a10084c622a21949ef877db8eada2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b7c1c4102662966b249af98f409fafc0c886258276f294adeec835ff21a1122"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84e634df3bb3034f1ef326d4f387280d161938a2897b9fbb3991839dd88f8f64"
  end

  depends_on "go" => :build

  def install
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
