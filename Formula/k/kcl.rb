class Kcl < Formula
  desc "CLI for the KCL programming language"
  homepage "https://github.com/kcl-lang/cli"
  url "https://github.com/kcl-lang/cli/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "b4cb6ea7ab36a7a5ca94316e5db49852c703c83233f7a4da5c73a2ecee24b8fa"
  license "Apache-2.0"
  head "https://github.com/kcl-lang/cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73cffb1c7f0f73c5fec0d9beab91eb9a57262bacf79c85865e1212d75adbad2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7397fe6e6ae57c383be682401ee299ab09f3c91be53fc4e7db4db11ee77458d6"
    sha256 cellar: :any_skip_relocation, ventura:       "7985e82a3a43d715e52d924038b2602fc94557eadf2f9dc28dc8e85dd916b6fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1127a6c7eaf3048a1842b2b0b07f14308873ed110fb13653f8bee96b9eaade2a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X kcl-lang.io/cli/pkg/version.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kcl"

    generate_completions_from_executable(bin/"kcl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kcl --version")

    (testpath/"test.k").write <<~EOS
      hello = "KCL"
    EOS
    assert_equal "hello: KCL", shell_output("#{bin}/kcl run #{testpath}/test.k").chomp
  end
end
