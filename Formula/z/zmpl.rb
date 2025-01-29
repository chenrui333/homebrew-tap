class Zmpl < Formula
  desc "Templating language written in Zig"
  homepage "https://github.com/jetzig-framework/zmpl"
  url "https://github.com/jetzig-framework/zmpl/archive/refs/tags/zig-0.13.tar.gz"
  sha256 "1554c75516c3e225fd7881e54bf69150cd14036f01d3b644368d41bc7c6d1710"
  license "MIT"

  depends_on "zig" => [:build, :test]

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = %W[
      --prefix #{prefix}
      -Doptimize=ReleaseSafe
    ]

    args << "-Dcpu=#{cpu}" if build.bottle?
    system "zig", "build", *args
  end

  test do
    (testpath/"hello.zmpl").write <<~EOS
      Hello, { name }!
    EOS

    (testpath/"test.zig").write <<~EOS
      const std = @import("std");
      const zmpl = @import("zmpl");

      pub fn main() !void {
          var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
          defer arena.deinit();
          const allocator = &arena.allocator;

          const data = try std.fs.readToAlloc(allocator, "./hello.zmpl", std.ascii);
          defer allocator.free(data);

          // Create a new context
          const context = zmpl.Context.new(allocator);
          defer context.deinit();

          // Set key-value pair for templating
          try context.set("name", "World");

          // Render the template
          const result = try zmpl.render(allocator, data, context);
          defer allocator.free(result);

          // Print the result to stdout
          std.debug.print("{}\\n", .{ result });
      }
    EOS

    system "zig", "build-exe", "test.zig",
           "--library-path", lib,
           "--library", "zmpl",
           "-Doptimize=ReleaseSafe"

    output = shell_output("./test")
    assert_match "Hello, World!", output
  end
end
