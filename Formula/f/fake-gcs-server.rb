class FakeGcsServer < Formula
  desc "Emulator for Google Cloud Storage API"
  homepage "https://github.com/fsouza/fake-gcs-server"
  url "https://github.com/fsouza/fake-gcs-server/archive/refs/tags/v1.52.3.tar.gz"
  sha256 "ef7d6719d9a824a5614808c9408bd3dd73dda1049feaa7f65442b1c44602aa13"
  license "BSD-3-Clause"
  head "https://github.com/fsouza/fake-gcs-server.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60732bc78c433a232c2f3661dccde342cb8f7f31e81396d9433f4633e6f1bb70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60732bc78c433a232c2f3661dccde342cb8f7f31e81396d9433f4633e6f1bb70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60732bc78c433a232c2f3661dccde342cb8f7f31e81396d9433f4633e6f1bb70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3975d421d77ff8d1613643ecc9293ec64e71c9f059f971356f19189df7225b83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebb94af15e5bc8a3b1ea551d279d76066a93ea8b9017b39e3418de71c7dae3cb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/fsouza/fake-gcs-server.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    port = free_port

    pid = spawn bin/"fake-gcs-server", "-host", "127.0.0.1", "-port", port.to_s,
                    "-backend", "memory", "-log-level", "warn"
    sleep 2

    begin
      output = shell_output("curl -k -s 'https://127.0.0.1:#{port}/storage/v1/b?project=test'")
      assert_equal "{\"kind\":\"storage#buckets\"}", output.strip

      # Create a bucket
      shell_output("curl -k -s -X POST 'https://127.0.0.1:#{port}/storage/v1/b?project=test' " \
                   "-H 'Content-Type: application/json' -d '{\"name\": \"test-bucket\"}'")

      # Verify bucket exists
      output = shell_output("curl -k -s 'https://127.0.0.1:#{port}/storage/v1/b?project=test'")
      assert_equal "test-bucket", JSON.parse(output)["items"][0]["id"]
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
