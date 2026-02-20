#!/bin/bash

# این فایل توسط هوش مصنوعی برای آسان تر شدن اجرای کدها نوشته شده است

# runner.sh - اسکریپت اجرای تمام تست‌های پروژه بازی تاس

# تعریف مسیرها
RTL_PATH="./RTL"
TB_PATH="./TB"
DATAPATH_PATH="$RTL_PATH/DataPath"
CONTROLLER_PATH="$RTL_PATH/Controller"

echo "========================================"
echo "   اجرای تست‌های پروژه بازی تاس       "
echo "========================================"
echo "مسیر RTL: $RTL_PATH"
echo "مسیر TB: $TB_PATH"
echo "مسیر DataPath: $DATAPATH_PATH"
echo "مسیر Controller: $CONTROLLER_PATH"
echo "========================================"

# پاک کردن فایل‌های قبلی
echo "پاک کردن فایل‌های قبلی..."
rm -f *.o *.cf *.vcd

# تابع برای اجرای تست و نمایش waveform
run_test() {
    local test_name=$1
    local vcd_file=$2
    
    echo ""
    echo "--- $test_name ---"
    echo "برای ادامه $test_name را ببندید"
    echo ""
    
    # اجرای GTKWave در background
    if [ -f "$vcd_file" ]; then
        gtkwave $vcd_file &
        
        # صبر کردن تا کاربر Enter بزند
        echo "پس از مشاهده waveform، Enter را بزنید..."
        read
        
        # بستن GTKWave
        pkill -f gtkwave
    else
        echo "❌ فایل $vcd_file پیدا نشد!"
        read
    fi
}

# بررسی وجود فایل‌های تست‌بنچ
check_tb_file() {
    local tb_file="$TB_PATH/$1"
    if [ ! -f "$tb_file" ]; then
        echo "❌ خطا: فایل $tb_file پیدا نشد!"
        return 1
    fi
    return 0
}

echo ""
echo "🔄 بررسی فایل‌های تست‌بنچ..."

# تست شمارنده (counter)
echo ""
echo "--- تست شمارنده (counter) ---"
if check_tb_file "TB_counter.vhd"; then
    ghdl -a "$DATAPATH_PATH/Counter.vhd"
    ghdl -a "$TB_PATH/TB_counter.vhd"
    ghdl -e counter_tb
    ghdl -r counter_tb --vcd=counter_tb.vcd --stop-time=500ns
    run_test "تست شمارنده" "counter_tb.vcd"
fi

# تست نمایشگر ۷ سگمنت
echo ""
echo "--- تست نمایشگر ۷ سگمنت ---"
if check_tb_file "Tb_sevenSeg.vhd"; then
    ghdl -a "$DATAPATH_PATH/7-Seg.vhd"
    ghdl -a "$TB_PATH/Tb_sevenSeg.vhd"
    ghdl -e seven_segment_tb
    ghdl -r seven_segment_tb --vcd=seven_segment_tb.vcd --stop-time=100ns
    run_test "تست ۷ سگمنت" "seven_segment_tb.vcd"
fi

# تست جمع‌کننده
echo ""
echo "--- تست جمع‌کننده (adder) ---"
if check_tb_file "TB_Adder.vhd"; then
    ghdl -a "$DATAPATH_PATH/Adder.vhd"
    ghdl -a "$TB_PATH/TB_Adder.vhd"
    ghdl -e adder_tb
    ghdl -r adder_tb --vcd=adder_tb.vcd --stop-time=100ns
    run_test "تست جمع‌کننده" "adder_tb.vcd"
fi

# تست ثبات point
echo ""
echo "--- تست ثبات point ---"
if check_tb_file "TB_PointReg.vhd"; then
    ghdl -a "$DATAPATH_PATH/PointReg.vhd"
    ghdl -a "$TB_PATH/TB_PointReg.vhd"
    ghdl -e point_register_tb
    ghdl -r point_register_tb --vcd=point_register_tb.vcd --stop-time=200ns
    run_test "تست ثبات point" "point_register_tb.vcd"
fi

# تست مقایسه‌کننده
echo ""
echo "--- تست مقایسه‌کننده (comparator) ---"
if check_tb_file "TB_Comparator.vhd"; then
    ghdl -a "$DATAPATH_PATH/Comparator.vhd"
    ghdl -a "$TB_PATH/TB_Comparator.vhd"
    ghdl -e comparator_tb
    ghdl -r comparator_tb --vcd=comparator_tb.vcd --stop-time=100ns
    run_test "تست مقایسه‌کننده" "comparator_tb.vcd"
fi

# تست منطق
echo ""
echo "--- تست منطق (test_logic) ---"
if check_tb_file "TB_testLogic.vhd"; then
    ghdl -a "$DATAPATH_PATH/Testlogic.vhd"
    ghdl -a "$TB_PATH/TB_testLogic.vhd"
    ghdl -e test_logic_tb
    ghdl -r test_logic_tb --vcd=test_logic_tb.vcd --stop-time=200ns
    run_test "تست منطق" "test_logic_tb.vcd"
fi

# تست کنترلر (FSM)
echo ""
echo "--- تست کنترلر (FSM) ---"
if check_tb_file "TB_FSM.vhd"; then
    ghdl -a "$CONTROLLER_PATH/FSM.vhd"
    ghdl -a "$TB_PATH/TB_FSM.vhd"
    ghdl -e fsm_controller_tb
    ghdl -r fsm_controller_tb --vcd=fsm_controller_tb.vcd --stop-time=500ns
    run_test "تست کنترلر" "fsm_controller_tb.vcd"
fi

# تست سیستم کامل
echo ""
echo "--- تست سیستم کامل ---"
if check_tb_file "TB_DiceGame.vhd"; then
    echo "آنالیز همه فایل‌های مورد نیاز برای سیستم کامل..."
    
    # آنالیز همه فایل‌های مورد نیاز به ترتیب وابستگی
    ghdl -a "$DATAPATH_PATH/Counter.vhd"
    ghdl -a "$DATAPATH_PATH/7-Seg.vhd"
    ghdl -a "$DATAPATH_PATH/Adder.vhd"
    ghdl -a "$DATAPATH_PATH/PointReg.vhd"
    ghdl -a "$DATAPATH_PATH/Comparator.vhd"
    ghdl -a "$DATAPATH_PATH/Testlogic.vhd"
    ghdl -a "$CONTROLLER_PATH/FSM.vhd"
    ghdl -a "$RTL_PATH/DiceGame.vhd"
    ghdl -a "$TB_PATH/TB_DiceGame.vhd"
    ghdl -e dice_game_top_tb
    ghdl -r dice_game_top_tb --vcd=dice_game_top_tb.vcd --stop-time=1us
    run_test "تست سیستم کامل" "dice_game_top_tb.vcd"
fi

echo ""
echo "========================================"
echo "   تمام تست‌ها با موفقیت اجرا شدند!    "
echo "========================================"