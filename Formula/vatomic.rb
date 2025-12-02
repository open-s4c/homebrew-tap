class Vatomic < Formula
  desc "vatomic is a header library of atomics operations, supporting mainstream architectures: ARMv7, ARMv8 (AArch32 and AArch64), RISC-V, and x86_64."
  homepage "https://github.com/open-s4c/vatomic"
  url "https://github.com/open-s4c/vatomic/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "3fac5ac41cee69528e7123525fff3bc2cb4c9fd9a31169f4b18b8622765aca6d"
  license "MIT"

  def install
    include.install Dir["include/*"]
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <vsync/atomic.h>
      #include <stdio.h>

      vatomic32_t count;

      int main() {
        vatomic_inc(&count);
        printf("count: %u\\n", vatomic_read(&count));
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}"
  end
end
